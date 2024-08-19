
# SQL Injection Exploitation Report

**Target URL:**  
`http://testphp.vulnweb.com/`

**Vulnerable Page:**  
`http://testphp.vulnweb.com/search.php?test=query%27`

**Objective:**  
To perform a SQL injection attack on the target website and extract sensitive data from its database.

### Steps Taken:

1. **Identifying the Vulnerable Input Field:**
    
    - The `test` parameter in the URL `http://testphp.vulnweb.com/search.php?test=query%27` was found to be vulnerable to SQL injection.

![[Pasted image 20240819214939.png]]

2. **Using SQLmap for Automated Exploitation:**
    
    - SQLmap was employed to automate the process of exploiting the SQL injection vulnerability. The command used was:
        
        
        `sqlmap -u "http://testphp.vulnweb.com/search.php?test=" --batch --dump`
        
    - SQLmap successfully identified the SQL injection vulnerability, enumerated the database, and extracted data from various tables.

![[Pasted image 20240819215136.png]]

3. **Extracted Data:**
    
    - The following data was extracted from the database `acuart`:
        - **Table `users`:**
            - Contains sensitive information such as credit card numbers, email addresses, usernames, and passwords.
        - **Table `featured`:**
            - Contains columns like `pic_id` and `feature_text`, but the table appears to be empty.
        - **Table `guestbook`:**
            - Contains columns like `mesaj`, `sender`, and `senttime`, but the table appears to be empty.

![[Pasted image 20240819215355.png]]

![[Pasted image 20240819215445.png]]
### Conclusion:

The SQL injection vulnerability in the `test` parameter of the `search.php` page allowed us to extract sensitive data from the database, highlighting a serious security risk. The data includes critical information like credit card numbers and passwords. To protect the application from such attacks, it's important to use input validation and prepared statements.

---

**Group Members:**

- **Vishwa J** (22BAD116)
- **Yogesh C** (22BAD118)
- **Charaneesh A P** (22BAD119)