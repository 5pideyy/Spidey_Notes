
 TARGET http://testphp.vulnweb.com/



http://testphp.vulnweb.com/search.php?test=query%27


![[Pasted image 20240819214939.png]]


![[Pasted image 20240819215136.png]]


![[Pasted image 20240819215355.png]]

![[Pasted image 20240819215445.png]]




### SQL Injection Exploitation Report

**Target URL:**  
`http://testphp.vulnweb.com/`

**Vulnerable Page:**  
`http://testphp.vulnweb.com/search.php?test=query%27`

**Objective:**  
To perform a SQL injection attack on the target website and extract sensitive data from its database.

### Steps Taken:

1. **Identifying the Vulnerable Input Field:**
    
    - The `test` parameter in the URL `http://testphp.vulnweb.com/search.php?test=query%27` was found to be vulnerable to SQL injection.
2. **Manual SQL Injection Attempt:**
    
    - Initially, manual attempts to perform SQL injection by appending common SQL payloads like `' UNION SELECT username, password FROM users --` to the URL did not yield any visible data. This indicated the presence of SQL injection but possibly required a more complex payload or the use of automated tools.
3. **Using SQLmap for Automated Exploitation:**
    
    - SQLmap was employed to automate the process of exploiting the SQL injection vulnerability. The command used was:
        
        bash
        
        Copy code
        
        `sqlmap -u "http://testphp.vulnweb.com/search.php?test=" --batch --dump`
        
    - SQLmap successfully identified the SQL injection vulnerability, enumerated the database, and extracted data from various tables.
4. **Extracted Data:**
    
    - The following data was extracted from the database `acuart`:
        - **Table `users`:**
            - Contains sensitive information such as credit card numbers, email addresses, usernames, and passwords.
        - **Table `featured`:**
            - Contains columns like `pic_id` and `feature_text`, but the table appears to be empty.
        - **Table `guestbook`:**
            - Contains columns like `mesaj`, `sender`, and `senttime`, but the table appears to be empty.

### Screenshots Documentation:

- **Screenshot 1:** (filename: `Pasted image 20240819214939.png`)
    
    - This screenshot shows the initial SQLmap command execution, identifying the backend DBMS as MySQL and testing various injection points.
- **Screenshot 2:** (filename: `Pasted image 20240819215136.png`)
    
    - The screenshot shows SQLmap continuing the testing and successfully enumerating the database `acuart`.
- **Screenshot 3:** (filename: `Pasted image 20240819215355.png`)
    
    - This screenshot displays the data extracted from the `users` table, which includes sensitive information like credit card numbers, emails, usernames, and passwords.
- **Screenshot 4:** (filename: `Pasted image 20240819215445.png`)
    
    - The final screenshot shows the extracted data being saved into CSV files by SQLmap, which can be used for further analysis.


### Conclusion:

The SQL injection vulnerability in the `test` parameter of the `search.php` page allowed successful extraction of sensitive data from the database, demonstrating the critical nature of this vulnerability. The extracted data includes potentially harmful information like credit card numbers and passwords, indicating a severe security risk. Proper remediation steps, such as input validation and the use of prepared statements, should be taken to secure the application from SQL injection attacks.


