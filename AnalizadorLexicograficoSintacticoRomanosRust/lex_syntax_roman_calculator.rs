// Calculadora de Números Romanos en Rust
use std::io;
#[derive(Debug, PartialEq, Clone)]
pub enum Token {
    Romano(String),
    Mas,
    Menos,
    Multiplicar,
    Dividir,
    ParentesisIzquierdo,
    ParentesisDerecho,
}
// Analisis Lexicografico
fn is_roman_char(c: char) -> bool {
    matches!(c, 'I' | 'V' | 'X' | 'L' | 'C' | 'D' | 'M')
}
pub fn lex(input: &str) -> Vec<Token> {
    let mut tokens = Vec::new();
    let mut chars = input.chars().peekable();
    while let Some(&ch) = chars.peek() {
        match ch {
            '+' => { tokens.push(Token::Mas); chars.next(); }
            '-' => { tokens.push(Token::Menos); chars.next(); }
            '*' => { tokens.push(Token::Multiplicar); chars.next(); }
            '/' => { tokens.push(Token::Dividir); chars.next(); }
            '(' => { tokens.push(Token::ParentesisIzquierdo); chars.next(); }
            ')' => { tokens.push(Token::ParentesisDerecho); chars.next(); }
            ' ' | '\t' | '\n' => { chars.next(); }
            _ => {
                if is_roman_char(ch) {
                    let mut roman = String::new();
                    while let Some(&c) = chars.peek() {
                        if is_roman_char(c) {
                            roman.push(c);
                            chars.next();
                        } else {
                            break;
                        }
                    }
                    tokens.push(Token::Romano(roman));
                } else {
                    panic!("Error sintáctico: carácter inválido '{}'", ch);
                }
            }
        }
    }
    tokens
}

fn roman_to_int(s: &str) -> i32 {
    let mut result = 0;
    let chars: Vec<char> = s.chars().collect();
    let mut i = 0;

    while i < chars.len() {
        let val = match chars[i] {
            'I' => 1,
            'V' => 5,
            'X' => 10,
            'L' => 50,
            'C' => 100,
            'D' => 500,
            'M' => 1000,
            _ => panic!("Error sintáctico: número romano inválido"),
        };

        if i + 1 < chars.len() {
            let next_val = match chars[i + 1] {
                'I' => 1,
                'V' => 5,
                'X' => 10,
                'L' => 50,
                'C' => 100,
                'D' => 500,
                'M' => 1000,
                _ => 0,
            };

            if val < next_val {
                result += next_val - val;
                i += 2;
                continue;
            }
        }

        result += val;
        i += 1;
    }

    result
}

fn int_to_roman(mut num: i32) -> String {
    if num <= 0 {
        panic!("Error sintáctico: el resultado no puede ser romano");
    }

    let val = [1000,900,500,400,100,90,50,40,10,9,5,4,1];
    let rom = ["M","CM","D","CD","C","XC","L","XL","X","IX","V","IV","I"];

    let mut result = String::new();
    for (i, &v) in val.iter().enumerate() {
        while num >= v {
            result.push_str(rom[i]);
            num -= v;
        }
    }
    result
}

// Analisis Sintáctico
fn parse_expr(tokens: &[Token]) -> (i32, usize) {
    let (value, pos) = parse_add_sub(tokens, 0);
    if pos != tokens.len() {
        panic!("Error sintáctico: tokens sobrantes en la expresión");
    }
    (value, pos)
}
fn parse_add_sub(tokens: &[Token], pos: usize) -> (i32, usize) {
    let (mut value, mut pos) = parse_mul_div(tokens, pos);

    while pos < tokens.len() {
        match tokens[pos] {
            Token::Mas => {
                if pos + 1 >= tokens.len() {
                    panic!("Error sintáctico: '+' sin operando derecho");
                }
                let (rhs, new_pos) = parse_mul_div(tokens, pos + 1);
                value += rhs;
                pos = new_pos;
            }
            Token::Menos => {
                if pos + 1 >= tokens.len() {
                    panic!("Error sintáctico: '-' sin operando derecho");
                }
                let (rhs, new_pos) = parse_mul_div(tokens, pos + 1);
                value -= rhs;
                pos = new_pos;
            }
            _ => break,
        }
    }

    (value, pos)
}

fn parse_mul_div(tokens: &[Token], pos: usize) -> (i32, usize) {
    let (mut value, mut pos) = parse_primary(tokens, pos);
    while pos < tokens.len() {
        match tokens[pos] {
            Token::Multiplicar => {
                if pos + 1 >= tokens.len() {
                    panic!("Error sintáctico: '*' sin operando derecho");
                }
                let (rhs, new_pos) = parse_primary(tokens, pos + 1);
                value *= rhs;
                pos = new_pos;
            }
            Token::Dividir => {
                if pos + 1 >= tokens.len() {
                    panic!("Error sintáctico: '/' sin operando derecho");
                }
                let (rhs, new_pos) = parse_primary(tokens, pos + 1);
                value /= rhs;
                pos = new_pos;
            }
            _ => break,
        }
    }
    (value, pos)
}

fn parse_primary(tokens: &[Token], pos: usize) -> (i32, usize) {
    if pos >= tokens.len() {
        panic!("Error sintáctico: se esperaba un operando");
    }
    match &tokens[pos] {
        Token::Romano(s) => (roman_to_int(s), pos + 1),
        Token::ParentesisIzquierdo => {
            let (value, new_pos) = parse_add_sub(tokens, pos + 1);

            if new_pos >= tokens.len() {
                panic!("Error sintáctico: falta ')'");
            }
            match tokens[new_pos] {
                Token::ParentesisDerecho => (value, new_pos + 1),
                _ => panic!("Error sintáctico: se esperaba ')'")
            }
        }
        Token::ParentesisDerecho => {
            panic!("Error sintáctico: ')' inesperado");
        }
        _ => panic!("Error sintáctico: token inválido"),
    }
}
fn main() {
    let mut expr = String::new();
    println!("Por favor ingrese una expresión aritmética para números romanos:"); 
    io::stdin()
        .read_line(&mut expr)
        .expect("Fallo");
    let tokens = lex(&expr.trim());
    println!("Tokens: {:?}", tokens);
    let (resultado, _) = parse_expr(&tokens);
    println!("Resultado entero: {}", resultado);
    println!("Resultado romano: {}", int_to_roman(resultado));
}
