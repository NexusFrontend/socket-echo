use futures::stream::StreamExt;
use futures::SinkExt;
use std::net::SocketAddr;
use std::sync::Arc;
use tokio::net::{TcpListener, TcpStream};
use tokio::sync::Mutex;
use tokio_tungstenite::accept_async;
use tokio_tungstenite::WebSocketStream;

#[tokio::main]
async fn main() {
    let addr = "0.0.0.0:3847".parse::<SocketAddr>().unwrap();
    let listener = TcpListener::bind(&addr).await.unwrap();
    println!("WebSocket server is running on ws://{}", addr);

    while let Ok((stream, _)) = listener.accept().await {
        let stream = Arc::new(Mutex::new(stream));
        let stream_clone = Arc::clone(&stream);

        tokio::spawn(async move {
            handle_client(stream_clone).await;
        });
    }
}

async fn handle_client(stream: Arc<Mutex<TcpStream>>) {
    let val1 = Arc::try_unwrap(stream);
    if val1.is_err() {
        return;
    }
    let val2 = val1.unwrap().into_inner();

    let ws_stream = match accept_async(val2).await {
        Ok(ws_stream) => ws_stream,
        Err(e) => {
            println!("Error: {}", e);
            return;
        }
    };

    if let Err(e) = handle_ws(ws_stream).await {
        println!("Error: {}", e);
    }
}

async fn handle_ws(ws_stream: WebSocketStream<TcpStream>) -> Result<(), tungstenite::Error> {
    // Split the WebSocket stream into a sender and receive of messages
    let (mut write, mut read) = ws_stream.split();

    while let Some(msg) = read.next().await {
        if msg.is_err() {
            return Ok(());
        }

        let msg = msg.unwrap();

        if msg.len() > 512 {
            // Disconnect the client
            let r = write.close().await;
            if r.is_err() {}
            // exit
            return Ok(());
        }

        let r = write.send(msg).await;
        if r.is_err() {
            return Ok(());
        }
    }

    Ok(())
}
