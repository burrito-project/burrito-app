# Publishing Your App to the Google Play Store

## 1. Make sure the server is running
Before submitting your app to an app store, it’s important to verify that the server your app relies on is live, functional, and ready to handle requests. Many app stores require apps to provide real functionality and not just placeholders, so they might review the app’s responses to verify it’s working as expected.

- Check for Expected Responses: Test that the API is correctly providing the location of the burrito.
- Monitor Uptime: Many app stores may periodically check your app’s functionality during the review process. Consider using a monitoring service to alert you if your server goes down unexpectedly.

## 2. Make sure the app is using the correct API and not the local host
Check the ```lib/services/dio_client.dart``` file to ensure that the app is connected to the correct API endpoint. The ```baseUrl``` should be set to your live API URL, not localhost:

```json
baseUrl: 'https://yourAPI.com',
```
Now you are ready to publish the app in the store of your choice.