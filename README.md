# 🌐 WS Echo Service

The WS Echo Service is a lightweight WebSocket server used at NexusPIPE for displaying the latency on our [PoP Map](https://nexuspipe.com/locations).

This project allows you to, with minimal overhead, provide a multithreaded websocket-based echo service.

## 📁 Table of Contents

- [🌐 WS Echo Service](#-ws-echo-service)
  - [📁 Table of Contents](#-table-of-contents)
  - [🔌 Installation](#-installation)
  - [🖱️ Usage](#️-usage)
  - [🌲 Contributing](#-contributing)
  - [📜 License](#-license)


## 🔌 Installation

To use the WS Echo Service, follow these simple steps:

1. Clone the repository:
   ```shell
   git clone https://github.com/NexusFrontend/socket-echo.git
   ```

2. Change into the project directory:
   ```shell
   cd socket-echo
   ```

3. Install the dependencies (requires Rust and Cargo):
   ```shell
   make install
   ```

4. Build the project:
   ```shell
   make
   ```

## 🖱️ Usage

Once you have successfully installed and built the WS Echo Service, you can run it using the following command:

```zsh
$ ./release/latency-server
WebSocket server is running on ws://127.0.0.1:3847
```

The WebSocket server will start listening on `ws://127.0.0.1:3847`.

## 🌲 Contributing

Feel free to contribute to this project by creating issues, proposing new features, or submitting pull requests. We welcome your feedback and contributions!

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
