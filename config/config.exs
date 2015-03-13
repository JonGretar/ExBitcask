use Mix.Config

config :bitcask, :max_file_size, 2147483648
config :bitcask, :tombstone_version, 2
config :bitcask, :open_timeout, 4
config :bitcask, :sync_strategy, :none
config :bitcask, :require_hint_crc, false
config :bitcask, :merge_window, :always
config :bitcask, :frag_merge_trigger, 60
config :bitcask, :dead_bytes_merge_trigger, 536870912
config :bitcask, :frag_threshold, 40
config :bitcask, :dead_bytes_threshold, 134217728
config :bitcask, :small_file_threshold, 10485760
config :bitcask, :max_fold_age, -1
config :bitcask, :max_fold_puts, 0
config :bitcask, :expiry_secs, -1
