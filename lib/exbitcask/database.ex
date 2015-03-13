defmodule ExBitcask.Database do
  defstruct [ref: nil, folder: "", options: []]
  @type option :: :read_write | :sync_on_put
    | {:max_file_size, Integer.t}
    | {:open_timeout, Iteger.t}
    | {:expiry_secs, Integer.t}
    | {:max_fold_age, Integer.t}
    | {:max_fold_puts, Integer.t}
  @type options :: [option]
  @type t :: [ref: reference(), folder: String.t, options: List.t ]
  @moduledoc ~S"""
  """
end
