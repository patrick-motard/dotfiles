#!/usr/local/bin/python3
from __future__ import print_function
import httplib2
import os
import sys

from apiclient import discovery
from oauth2client import client
from oauth2client import tools
from oauth2client.file import Storage

from datetime import datetime, timedelta, time
from dateutil.parser import parse
import json

try:
    import argparse
    parser = argparse.ArgumentParser(parents=[tools.argparser])
    parser.add_argument('-c', '--calendar', action='store_true')
    parser.add_argument('-e', '--events', action='store_true')
    parser.add_argument('-a', '--add', action='store_true')
    parser.add_argument('-t', '--test', action='store_true')
    parser.add_argument('-u', '--update_event', nargs=2)
    flags = parser.parse_args()
    print(flags)
except ImportError:
    flags = None

# If modifying these scopes, delete your previously saved credentials
# at ~/.credentials/calendar-python-quickstart.json
SCOPES = 'https://www.googleapis.com/auth/calendar'
CLIENT_SECRET_FILE = 'credentials.json'
APPLICATION_NAME = 'Google Calendar API Python Quickstart'

def is_event_valid(event):
    return 'dateTime' in event['start']

def get_event_metadata(event, colors):
    date_obj = datetime.fromisoformat(event['start']['dateTime'])
    date_str = datetime.strftime(date_obj, "%A, %B %d")

    title = event['summary']
    time = parse(event['start'].get('dateTime', event['start'].get('date')))
    time = time.strftime("%I:%M %p").lstrip('0')

    # Convert numerical colorId to hex code
    try:
        hexColor = colors['event'][event['colorId']]['background']
    except KeyError:
        # Default color - blue
        hexColor = colors['event']['9']['background']

    print(event)

    return {
        'date_str': date_str,
        'title':title,
        'time':time,
        'color': hexColor,
        'colorId': event['colorId'] if 'colorId' in event else '9',
        'id':event['id']
        }

def get_credentials():
    """Gets valid user credentials from storage.

    If nothing has been stored, or if the stored credentials are invalid,
    the OAuth2 flow is completed to obtain the new credentials.

    Returns:
        Credentials, the obtained credential.
    """
    home_dir = os.path.expanduser('~') # /Users/kevzheng
    credential_dir = os.path.join(home_dir, '.credentials') # /Users/kevzheng/.credentials
    if not os.path.exists(credential_dir):
        os.makedirs(credential_dir)

    # /Users/kevzheng/.credentials/calendar-python-quickstart.json
    credential_path = os.path.join(credential_dir,
                                   'calendar-python-quickstart.json')

    store = Storage(credential_path)
    credentials = store.get()
    if not credentials or credentials.invalid:
        flow = client.flow_from_clientsecrets(CLIENT_SECRET_FILE, SCOPES)
        flow.user_agent = APPLICATION_NAME
        if flags:
            credentials = tools.run_flow(flow, store, flags)
        else: # Needed only for compatibility with Python 2.6
            credentials = tools.run(flow, store)
        print('Storing credentials to ' + credential_path)
    return credentials

def get_colors(service, colorfile):
    """
    If colorfile does not exist: fetches color mappings on gcal API
    otherwise, returns dictionary of colors from json colorfile
    """
    print('Fetching colors...')
    try:
        colors = json.load(open(colorfile, 'r'))
    except FileNotFoundError:
        colors = service.colors().get().execute()
        with open(colorfile, 'w') as jsonfile:
            json.dump(colors, jsonfile, indent=4)

    return colors

def refresh_calendars(service, filename):
    """Fetches user's calendars and asks user to activate them
    Calendars are only considered if ACTIVATED
    """
    print('Refreshing calendars...')

    data = {'calendars':{}}
    active = {}
    inactive = {}

    calendar_list = service.calendarList().list().execute()
    # Loop through calendars, set active or inactive
    for item in calendar_list['items']:
        active_flag = input(f"Activate {item['summary']} ? [y/N] ")
        if(str.lower(active_flag) == 'y'):
            active[item['summary']] = item['id']
        else:
            inactive[item['summary']] = item['id']

    data['calendars']['active'] = active
    data['calendars']['inactive'] = inactive

    # Update calendar data
    with open(filename, 'w') as jsonfile:
        json.dump(data, jsonfile, indent=4)

def refresh_events(service, pdelta, ndelta, calendarFile, outFile):
    """Fetches all events from previous (pdelta) to next (ndelta) hours from active calendars,
    then updates the events file
    """
    print('Refreshing events...')

    # Color information
    colors = get_colors(service, os.path.join(os.getcwd(), 'src/gcal/colors.json'))

    # Get time range from [yesterday, tomorrow)
    start = datetime.combine(datetime.today() - timedelta(days=1), time())
    end = start + timedelta(days=3)

    # Convert to google calendar API expected format
    start = start.isoformat() + 'Z'
    end = end.isoformat() + 'Z'

    # Calculating time deltas
    #start = (datetime.utcnow() - timedelta(hours=pdelta)).isoformat() + 'Z'
    #end = (datetime.utcnow() + timedelta(hours=ndelta)).isoformat() + 'Z'

    print(start)

    data = {'events':[]}
    calendar = json.load(open(calendarFile, 'r'))
    calendar['calendars']['active']['primary'] = 'primary'

    print(calendar['calendars']['active'].items())

    events = []

    for cal, cal_id in calendar['calendars']['active'].items():
        eventsResult = service.events().list(
            calendarId=cal_id, timeMin=start, timeMax=end, singleEvents=True).execute()
        events.extend(eventsResult.get('items', []))

    # filter events
    events = [x for x in events if is_event_valid(x)]

    # sort events by time
    events.sort(key=lambda x: parse(x['start']['dateTime']))

    date_events = {}
    for event in events:
        event_meta = get_event_metadata(event, colors)
        date_str = event_meta['date_str']
        if date_str in date_events:
            date_events[date_str]["events"].append(event_meta)
        else:
            date_events[date_str] = {"date": date_str, "events": [event_meta]}

    # convert keys to ordered integers
    ikeys = list(range(len(date_events)))
    date_events = dict(zip(ikeys, date_events.values()))

    print(date_events)

    # Update event file
    with open(outFile, 'w') as jsonfile:
        json.dump(date_events, jsonfile, indent=4)

def update_colors(service):
    """
    Updates all default-colored events within primary
    calendar to color of the week

    Color of the week is current_week % len(weekly_colors)
    """

    current_week = int(datetime.today().strftime("%V"))

    # Calculating time deltas
    current = datetime.today()
    start = current - datetime.timedelta(days=current.weekday())
    end = start + datetime.timedelta(days=6)

    start = start.isoformat() + 'Z'
    end = end.isoformat() + 'Z'

    eventsResult = service.events().list(
        calendarId='primary', timeMin=start, timeMax=end, singleEvents=True,
        orderBy='startTime').execute()

    for event in eventsResult['items']:
        if 'colorId' not in event:
            print(f"Updating color: {event['summary']}", end='\n')
            event['colorId'] = weekly_colors[current_week % len(weekly_colors)]
            service.events().update(calendarId='primary', eventId=event['id'], body=event).execute()

"""
Test functions begin
"""

def update_event(service, id, color):
    event = service.events().get(calendarId='primary', eventId=id).execute()
    event['colorId'] = color
    service.events().update(calendarId='primary', eventId=id, body=event).execute()

def add_event(service, summary, start, end):
    event = {
        'summary': f'Google I/O 2015',
        'description': 'A chance to hear more about Google\'s developer products.',
        'start': {
            'dateTime': '2017-10-30T00:18:00.0000007Z',
            'timeZone': 'America/Los_Angeles',
        },
        'end': {
            'dateTime': '2017-10-30T00:42:00.000000Z',
            'timeZone': 'America/Los_Angeles',
        },
        'reminders': {
            'useDefault': True,
        }
    }

    event = service.events().insert(calendarId='primary', body=event).execute()
    print('Event created: %s' % (event.get('htmlLink')))

def test(service):
    calendar_list = service.calendarList().list().execute()
    out = { item['summary'] : item['id'] for item in calendar_list['items'] }
    print(out)
    with open('calendar_test.json', 'w') as outfile:
        json.dump({'calendars' : out}, outfile, indent=4)
    # for item in calendar_list['items']:
    #     print(item['summary'])
    #     print(item['id'])
    #     print('\n')
    # print(calendar_list)


"""
Test functions end
"""

def main():
    """
    Creates a Google Calendar API service object
    Can interact with list of calendars, events
    """

    # Creates service object
    credentials = get_credentials()
    http = credentials.authorize(httplib2.Http())
    service = discovery.build('calendar', 'v3', http=http)

    # Gets all calendars
    if(flags.calendar):
        refresh_calendars(service, os.path.join(os.getcwd(), 'src/gcal/calendar.json'))

    # Gets all events
    if(flags.events):
        refresh_events(service, 48, 48, os.path.join(os.getcwd(), 'src/gcal/calendar.json'), os.path.join(os.getcwd(), 'src/gcal/events.json'))

    if(flags.update_event):
        update_event(service, *flags.update_event)

    if(flags.add):
        add_event(service)

    if(flags.test):
        test(service)
        return

if __name__ == '__main__':
    main()
