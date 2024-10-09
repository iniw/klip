use std::io::{stdin, IsTerminal, Read};
use std::{env, error::Error};

use cli_clipboard::{ClipboardContext, ClipboardProvider};

fn main() -> Result<(), Box<dyn Error>> {
    let mut clipboard = ClipboardContext::new()?;

    match env::args().nth(1) {
        Some(text) => clipboard.set_contents(text)?,
        None if !stdin().is_terminal() => {
            let mut input = String::new();
            stdin().read_to_string(&mut input)?;
            clipboard.set_contents(input)?;
        }
        None => {
            print!("{}", clipboard.get_contents()?);
        }
    };

    Ok(())
}
