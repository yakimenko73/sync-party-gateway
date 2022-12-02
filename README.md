# <p align="center">Sync-party gateway</p>

[![Pray for Ukraine](https://img.shields.io/badge/made_in-ukraine-ffd700.svg?labelColor=0057b7)](https://stand-with-ukraine.pp.ua)
[![Licence](https://img.shields.io/github/license/yakimenko73/sync-party-gateway)](https://github.com/yakimenko73/sync-party-gateway/blob/master/LICENSE)
[![Deploy](https://github.com/yakimenko73/sync-party-gateway/actions/workflows/docker-image.yml/badge.svg)](https://github.com/yakimenko73/sync-party-gateway/actions/workflows/docker-image.yml)
[![Code factor](https://www.codefactor.io/repository/github/yakimenko73/sync-party-gateway/badge)](https://www.codefactor.io/repository/github/yakimenko73/sync-party-gateway)

## What is it?
Elixir websocket gateway for real-time Sync-party site operation

### Built With
* [Plug](https://hexdocs.pm/plug/readme.html)
* [Plug-cowboy](https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html)
* [Jason](https://hexdocs.pm/jason/readme.html)
* [HTTPoison](https://hexdocs.pm/httpoison/HTTPoison.html)
* [Mongodb](https://www.mongodb.com/)

## Getting Started
This tutorial will help you run server locally

### Installation
Requires Elixir >= 1.13

1. Clone the repo
  ```sh
  git clone https://github.com/yakimenko73/sync-party-gateway.git
  ```
2. Get project deps
  ```sh
  mix deps.get
  ```
3. Run in dev mode with
  ```sh
  iex -S mix
  ````
The HTTP server is listening on port `4000` by default. The websocket endpoint is located at `ws://localhost:4000/ws` Connected clients are closed if inactive longer than `60s`. This can be changed in config/config.exs together with port and ws_endpoint.

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/amazing-feature`)
3. Commit your Changes (`git commit -m 'Add some amazing-feature'`)
4. Push to the Branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Contact

* Twitter - [@masterslave_](https://twitter.com/masterslave_)
* Email - r.yakimenko.73@gmail.com
