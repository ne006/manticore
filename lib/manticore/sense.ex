defmodule Manticore.Sense do
  def process(opts) do
    prey = Keyword.get(opts, :prey, nil)
    fangs = Keyword.get(opts, :fangs, 1)
    venom = Keyword.get(opts, :venom, nil)
    store = Keyword.get(opts, :store, nil)
  end
end
