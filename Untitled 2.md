A security vulnerability has been identified involving the accidental exposure of a Google Maps API key, which could be exploited by a malicious actor to consume company resources, leading to potential financial loss or service disruptions.

**Incident Details:**

- **Exposed API Key Screenshot:**  
	Below is a screenshot of the vulnerable JavaScript file, highlighting the exposed API key:

- **Vulnerable API Key:**  
    The exposed API key is publicly accessible in the following resource:
    
    - **URL**: [Annual Report JavaScript File](https://www.northwesternmutual.com/react-assets/templates/vendors~__react_static_root__/src/pages/annualReport/2023~__react_static_root__/src/pages/annualRepo~50e84712.e8c02b4e.js)
    
    The API key found is:
    
    - **API Key**: `AIzaSyDoQaSl4iGvxiUrd4qNm2AzJob3SPNpkeI`
    
    This key provides access to both the Staticmap API and the Streetview API, both of which can be exploited for financial gain or denial of service attacks if abused.
    
- **Exploitable API Endpoints:**
    
    - **Staticmap API**:  
        [PoC for Staticmap API](https://maps.googleapis.com/maps/api/staticmap?center=45%2C10&zoom=7&size=400x400&key=AIzaSyDoQaSl4iGvxiUrd4qNm2AzJob3SPNpkeI)  
        This link provides a static map with the specified coordinates, which could be used maliciously to exhaust the API quota.
        
    - **Streetview API**:  
        [PoC for Streetview API](https://maps.googleapis.com/maps/api/streetview?size=400x400&location=40.720032,-73.988354&fov=90&heading=235&pitch=10&key=AIzaSyDoQaSl4iGvxiUrd4qNm2AzJob3SPNpkeI)  
        This link provides a streetview image of a specific location, and similar to the Staticmap API, it can be abused to consume resources rapidly.
        

---

**Impact Assessment:**

If an attacker gains unauthorized access to the exposed API key, the following consequences could arise:

1. **Financial Damage:**
    - The key is not configured with usage restrictions, which could result in unauthorized usage.
    - The company could incur financial losses due to excessive billing for API calls, particularly since Google charges based on usage.
2. **Denial of Service:**
    - If any billing or usage controls are configured on the Google account, an attacker could cause a denial-of-service (DoS) by exhausting the allocated API quota.
    - This could result in service disruptions, especially for core services relying on the Maps APIs, such as mapping or location-based functionalities (e.g., Uber-like services or hotel search platforms like Booking.com).

---

**Potential Financial Impact (Cost Table):**

|**API Endpoint**|**Cost per 1000 Requests**|
|---|---|
|Staticmap API|$2 per 1000 requests|
|Streetview API|$7 per 1000 requests|

For up-to-date pricing information, please refer to:

- [Google Maps Platform Pricing](https://cloud.google.com/maps-platform/pricing)
- [Google Maps Billing Guide](https://developers.google.com/maps/billing/gmp-billing)

Given the pricing structure, an attacker could rack up significant costs if the key were used maliciously for a large number of requests.

---

**Recommendation:**

1. **Immediate Action:**
    
    - Revoke the exposed API key and generate a new one.
    - Configure the new API key with appropriate security settings, such as:
        - **API key restrictions**: Limit usage to specific IP addresses, HTTP referrers, or applications that should access the API.
        - **Usage Quotas**: Set usage limits to avoid over-billing.
        - **Billing Alerts**: Set up billing alerts for early detection of abnormal usage patterns.
2. **Security Best Practices:**
    
    - Use environment variables or a secure secrets management service to store sensitive information like API keys, instead of embedding them directly in frontend code.
    - Regularly review exposed API keys and ensure they are protected from unauthorized access.
3. **Monitoring and Detection:**
    
    - Implement monitoring on the usage of API keys to detect unusual spikes in usage or traffic patterns indicative of malicious activity.

By implementing these changes, the risk of unauthorized API usage and potential financial loss can be significantly mitigated.