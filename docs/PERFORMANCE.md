# Performance Testing

To benchmark shell startup time improvements:

```shell
# Install hyperfine
brew install hyperfine

# Benchmark shell startup
hyperfine --warmup 3 'zsh -i -c exit'
```

Current performance (as of 2025-11-16):
```
Benchmark 1: zsh -i -c exit
  Time (mean ± σ):     272.6 ms ±   7.4 ms    [User: 182.6 ms, System: 94.1 ms]
  Range (min … max):   262.9 ms … 283.7 ms    10 runs
```
