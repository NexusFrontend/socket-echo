build:
	cargo build --release

install:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

run:
	cargo run --release
