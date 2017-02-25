defmodule Decocare.History.CalBGForPH do
  use Bitwise
  alias Decocare.DateDecoder, as: DateDecoder

  def decode_cal_bg_for_ph(data = <<amount::8, timestamp::binary-size(5)>>) do
    <<_::size(16), amount_high_bit::size(1), _::size(15), amount_medium_bit::size(1), _::size(7)>> = timestamp
    %{
      amount: (amount_high_bit <<< 9) + (amount_medium_bit <<< 8) + amount,
      timestamp: DateDecoder.decode_history_timestamp(timestamp)
    }
  end
end