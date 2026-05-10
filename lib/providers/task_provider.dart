import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';
import '../services/firebase_service.dart';

class TaskProvider extends ChangeNotifier {
  final FirebaseService _firebaseService;
  bool _isLoading = false;
  String? _error;

  TaskProvider(this._firebaseService);

  bool get isLoading => _isLoading;
  String? get error => _error;

  Stream<List<TaskModel>> getTasks(String userId) {
    return _firebaseService.getTasks(userId);
  }

  Future<void> addTask(String title, String description, DateTime date) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final task = TaskModel(
      id: '',
      title: title,
      description: description,
      date: date,
      isCompleted: false,
      userId: user.uid,
    );

    _setLoading(true);
    try {
      await _firebaseService.addTask(task);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTask(TaskModel task) async {
    _setLoading(true);
    try {
      await _firebaseService.updateTask(task);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTask(String taskId) async {
    _setLoading(true);
    try {
      await _firebaseService.deleteTask(taskId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleTaskStatus(String taskId, bool isCompleted) async {
    _setLoading(true);
    try {
      await _firebaseService.toggleTaskStatus(taskId, isCompleted);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
