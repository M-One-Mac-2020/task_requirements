import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:task_requirements/core/config/app_constants.dart';
import 'package:task_requirements/core/service/notification/local_notification_handler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;


class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final LocalNotificationHandler _localNotificationHandler;

  FCMService(this._localNotificationHandler);

  Future<void> initialize() async {
    // Set presentation options for foreground messages (iOS)
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    debugPrint("FCM Token: $fcmToken");

    _setupForegroundMessageListener();
    _setupBackgroundMessageListener();
    await Future.delayed(Duration(seconds: 3));
    if (fcmToken == null) return;
    sendCustomNotification(targetToken: fcmToken);
  }

  void _setupForegroundMessageListener() {
    // When the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('FCM message received in foreground.');
      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null && android != null) {
        // Use the injected handler to display the notification
        _localNotificationHandler.show(
          title: notification.title ?? 'New Notification',
          body: notification.body ?? 'Check the latest updates.',
          payload: message.data.toString(),
        );
      }
    });
  }

  void _setupBackgroundMessageListener() {
    // When the user taps a notification from the background/terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('FCM message opened app from background.');
      // You can add routing logic here based on message data
    });
  }

  Future<String> getAccessToken() async {
    //project settings/service account / generate private new key
    Map<String, String> serviceAccountJson = {
      "type": "service_account",
      "project_id": "fir-app-ab020",
      "private_key_id": "428a451c2e2c78be5773b6c1d74e5d35061153a3",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCcE9MxLJwy8kHw\nq81W2MBXZu6IMjbIh7k36lwylKgoFZmpE/70UVo0f0jw9MEQ6UcauIoGgHtQjuT5\n4QnEgtlIZFww41kDpaSVjHdODUGJmYJeVlYXhPdxglBmwPTZ/cRpmF+9y9hOOPoQ\n+RhrfsSB4kiz/cA+HntdmI/iY1Ho6elTcyeLuhRFEz4ZI4f11SNfEi6LBIkymKMH\nxvQPTTHee+JP/NmXDDQveVPESR5FMzb1OPhEQP2Boj4YY41IoRLtQ+ud3hIO10sx\noG2unHq2jby5v3V9c3pGkcyB4SqcZHdqTC+wBHJiPuL0vFmU1hLiehBKfNHfBmjZ\nh1roJ5RRAgMBAAECggEABPJAGGtPQb8TNc2GcUKAj/rwKf4bZdrSFOwdgv3akwPV\nbfoQzUBE97jYwGG+7gQFyWdAeo9fH32z0uZ3Z1RCDuA29FatwMBixgy6UDP6Pnvd\nGZPELTRWnWQkztwKtnWrU2RglMfm+w2lTfay9/i/wTtnlFeBNiBdrQKGsGt3RYZ6\nTtJOD35GbpE0Y4zWXulfnh/EzSOkhy55kRxWTUbFNJEMZqdA2HVjstGjgmSgI5HF\nY/ixtPve4l6gAvBWA+O0i/0z1XYLnVhavZsLKWEFA9hNN52BNTvkMLt5+mK13wBX\nIwvNxuKvZWSsI7AL0LbcbHIgGURQ14ow9z/uj/iXhQKBgQDYjX8wFKvMRqwra5do\nX2Rpq7nxKYqCYDxTQ2CUVPOWU3Bp41XG53m5u7JD6Q3ZgW2h+a8dEQ0yAbpeDs+3\nEtSg9SxEkLv03uaxROj9OKXdxQxVNrkNUtLvsAZF7/+fX8fProrSmeJ7W93SdLrK\nv6JcJfviGsCKoE/eMauyBaCO3QKBgQC4gi8xte/80E5Q34ZtIqWJphvFyGqBofaO\ncgt4SQyBiZJIA8c/4gkkzj5+wOfRuQp+fS037FzctSVQtJ3FVUHyyuTWNUABycs7\nNlWKLo/+4dM3EckW6p0DYK3pzARVIaEhg37Z18/m+rw1n72UurqrjMFc2Lt1IhOC\nDazhxipSBQKBgASNpRj7tkkLS192Wa6mItRd+gDqILFxGJOfnQ5BYwXMJ1byosEV\n6OdQ3QS0h8gFAqsfNuFjlGVyx9pmcVOmH7ZqsU2XxXv2m98qVcPNRx+Mnx/DkMyI\n60qC5v7ddwCA4RCq2Nxow+xYGCfusGbG9MD/Q3aTnWzMxiEj5jpOB/w5AoGAO1vG\nixuZJaBuUZ5XxOyMjQgfjzW27hWJGLKf9gaqO1Ji+UAd7fNuNaUUffrZmaMKOT9U\nONWV2nt8kcZJq56OJOoZTMC84tZkx5vnURlBwiIsrV7Pbsvzz45e5QR5sFmtWPbQ\n7Ix9mjW4LxhBCYQ5Yc9ateAUDs7zr7dukwQJwXECgYBMgpC9srvqFUoRBxl31Mh8\nxaBw2TLaacgy0GBU0AGeTuhhCuL7kzHgkZtMYGcVOcV2aJaWUumk6cfoQoOOju8x\nbIZs2ARBOnBBznI+wG2UcHQ2vRH7QoHVIn8x+m9Y6WeDcLsx8AeH/SoRv+qBhEHJ\nOhV1V5Prrur7tPDuctei6A==\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-fbsvc@fir-app-ab020.iam.gserviceaccount.com",
      "client_id": "109153764982090130824",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40fir-app-ab020.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com",
    };
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );
    client.close();
    return credentials.accessToken.data;
  }

  Future<void> sendCustomNotification({
    String? targetToken,
    String title = "title",
    String body = "body ",
  }) async {
    targetToken ??= await _firebaseMessaging.getToken();
    String serverTokenKey = await getAccessToken();
    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $serverTokenKey'};

    final message = {
      'message': {
        'token': targetToken,
        'notification': {'title': title, 'body': body},
      },
    };

    try {
      final response = await http.post(
        Uri.parse(AppConstants.fcmUrl),
        headers: headers,
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        debugPrint('Notification sent successfully!');
      } else {
        debugPrint(
          'Failed to send notification.'
          ' Status code: ${response.statusCode}'
          '${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Error sending notification: $e');
    }
  }
}
