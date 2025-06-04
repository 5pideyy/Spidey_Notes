- **Carriage Return (CR)** - ASCII code 13 - makes cursor to return beginning of the current line `%0d`
- **Line Feed (LF)**- ASCII code 10 - makes cursor to move to the next line `%0a`


## TESTING

- **Find User Inputs:**
    
    - Identify all parameters accepting user input (e.g., query, headers, cookies).
        
- **Check Header Influence:**
    
    - See if user input appears in HTTP response headers.
        
- **Inject CRLF Payloads:**
    
    - Use `%0d%0a` to test if you can break or add headers.
        
- **Look for Vulnerabilities:**
    
    - **Response Splitting** – Add new headers.
        
    - **Cache Poisoning** – Alter caching rules.
        
    - **Session Fixation** – Modify session headers.



