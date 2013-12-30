# Exdrone

Exdrone is a client for the [Parrot ARDrone](http://ardrone2.parrot.com/).

[![YouTube Video](web/exdrone_youtube.png)](http://www.youtube.com/watch?v=f4LVJrAOq6s&feature=youtu.be)

## Usage

```elixir
connection = Exdrone.Connection[host: {192,168,1,1}, port: 5556]
alias Exdrone.Drone, as: D
{:ok, drone} = D.start(connection)
drone |> D.take_off
drone |> D.land
```

## Development

To run the tests:

```sh
mix test
```

To start a udp server that will log messages sent to it to a file:

```sh
nc -4 -u -l 2389 > /tmp/udp.data
```

## Resources

If you're interested in reading other sources re: how the ARDrone communication
protocol works, here are a few good ones:

- [Argus](http://github.com/jimweirich/argus) - the ruby library upon which this codebase is based.
- [How to Program the ARDrone over Wi-Fi](https://www.robotappstore.com/Knowledge-Base/How-to-Program-ARDrone-Remotely-Over-WIFI/96.html) is the first part of a nice series.
