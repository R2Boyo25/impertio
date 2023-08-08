import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :impertio, ImpertioWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "5py4psDz6lwrJdDoNdfrZ3Y9eDeTJi6xY10EARFMj5jKjaK7MXZU77i32iDZBxF9",
  server: false,
  data_dir: "test/data"

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
