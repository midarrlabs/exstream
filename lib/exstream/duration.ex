defmodule Exstream.Duration do

  def parse(<<hour::binary-size(1), ":", minutes::binary-size(2), ":", seconds::binary>>) do
    (String.to_integer(hour) * 3600) + (String.to_integer(minutes) * 60) + String.to_integer(seconds)
  end

  def parse(<<hours::binary-size(2), ":", minutes::binary-size(2), ":", seconds::binary>>) do
    (String.to_integer(hours) * 3600) + (String.to_integer(minutes) * 60) + String.to_integer(seconds)
  end

  def parse(<<"0:", seconds::binary>>) do
    String.to_integer(seconds)
  end

  def parse(<<minute::binary-size(1), ":", _seconds::binary>>) do
    String.to_integer(minute) * 60
  end

  def parse(<<minutes::binary-size(2), ":", seconds::binary>>) do
    (String.to_integer(minutes) * 60) + String.to_integer(seconds)
  end

  def get_second(<<_hour::binary-size(1), ":", _minutes::binary-size(2), ":", seconds::binary>>) do
    String.to_integer(seconds)
  end

  def get_second(<<_hours::binary-size(2), ":", _minutes::binary-size(2), ":", seconds::binary>>) do
    String.to_integer(seconds)
  end

  def get_minute(<<_hour::binary-size(1), ":", minutes::binary-size(2), ":", _seconds::binary>>) do
    String.to_integer(minutes)
  end

  def get_minute(<<_hours::binary-size(2), ":", minutes::binary-size(2), ":", _seconds::binary>>) do
    String.to_integer(minutes)
  end

  def get_hour(<<hour::binary-size(1), ":", _rest::binary>>) do
    String.to_integer(hour)
  end

  def get_hour(<<hours::binary-size(2), ":", _rest::binary>>) do
    String.to_integer(hours)
  end
end
