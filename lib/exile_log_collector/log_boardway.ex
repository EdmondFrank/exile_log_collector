defmodule ExileLogCollector.LogBoardway do
  use Broadway
  require Logger
  alias Broadway.Message

  def start_link(command) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        concurrency: 1,
        module: {StreamProducer, command},
        transformer: {StreamProducer, :transform, []}
      ],
      processors: [
        default: [
          concurrency: 10,
          min_demand: 0,
          max_demand: 1
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, %Message{data: data} = message, _) do
    Logger.info("Handling message: #{data}")
    message
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    messages
  end
end
