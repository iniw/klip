use std::io::{stdin, IsTerminal, Read};
use std::{env, error::Error};

use arboard::Clipboard;

fn main() -> Result<(), Box<dyn Error + Send + Sync>> {
    let mut clipboard = Clipboard::new()?;

    match env::args().nth(1) {
        Some(text) => clipboard.set_text(text)?,
        None if !stdin().is_terminal() => {
            let mut input = String::new();
            stdin().read_to_string(&mut input)?;
            clipboard.set_text(input)?;
        }
        None => {
            print!("{}", clipboard.get_text()?);
        }
    };

    Ok(())
}
