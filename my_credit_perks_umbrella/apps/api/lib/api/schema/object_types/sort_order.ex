defmodule Api.Schema.ObjectTypes.SortOrder do
  use Absinthe.Schema.Notation

  # By convention, enum values are passed in all uppercase letters.
  enum :sort_order do
    value(:asc)
    value(:desc)
  end
end
