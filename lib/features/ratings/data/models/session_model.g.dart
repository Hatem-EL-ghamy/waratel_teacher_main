// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionsResponse _$SessionsResponseFromJson(Map<String, dynamic> json) =>
    SessionsResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data:
          SessionsPaginatedData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionsResponseToJson(SessionsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

SessionsPaginatedData _$SessionsPaginatedDataFromJson(
        Map<String, dynamic> json) =>
    SessionsPaginatedData(
      sessions: (json['data'] as List<dynamic>)
          .map((e) => SessionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SessionsPaginatedDataToJson(
        SessionsPaginatedData instance) =>
    <String, dynamic>{
      'data': instance.sessions,
    };

SessionItem _$SessionItemFromJson(Map<String, dynamic> json) => SessionItem(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      channelName: json['channel_name'] as String,
      startAt: json['start_at'] as String,
      endAt: json['end_at'] as String,
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      maxParticipants: (json['max_participants'] as num).toInt(),
      status: json['status'] as String,
      isTeacherJoined: (json['is_teacher_joined'] as num).toInt(),
      teacher: json['teacher'] == null
          ? null
          : SessionTeacher.fromJson(json['teacher'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionItemToJson(SessionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'channel_name': instance.channelName,
      'start_at': instance.startAt,
      'end_at': instance.endAt,
      'duration_minutes': instance.durationMinutes,
      'max_participants': instance.maxParticipants,
      'status': instance.status,
      'is_teacher_joined': instance.isTeacherJoined,
      'teacher': instance.teacher,
    };

SessionTeacher _$SessionTeacherFromJson(Map<String, dynamic> json) =>
    SessionTeacher(
      id: (json['id'] as num).toInt(),
      profilePhotoPath: json['profile_photo_path'] as String?,
      user: json['user'] == null
          ? null
          : SessionUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionTeacherToJson(SessionTeacher instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profile_photo_path': instance.profilePhotoPath,
      'user': instance.user,
    };

SessionUser _$SessionUserFromJson(Map<String, dynamic> json) => SessionUser(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$SessionUserToJson(SessionUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
    };

StartSessionResponse _$StartSessionResponseFromJson(
        Map<String, dynamic> json) =>
    StartSessionResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: StartSessionData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StartSessionResponseToJson(
        StartSessionResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

StartSessionData _$StartSessionDataFromJson(Map<String, dynamic> json) =>
    StartSessionData(
      agoraToken: json['agora_token'] as String,
      channelName: json['channel_name'] as String,
      appId: json['app_id'] as String,
      uid: (json['uid'] as num).toInt(),
      role: json['role'] as String,
    );

Map<String, dynamic> _$StartSessionDataToJson(StartSessionData instance) =>
    <String, dynamic>{
      'agora_token': instance.agoraToken,
      'channel_name': instance.channelName,
      'app_id': instance.appId,
      'uid': instance.uid,
      'role': instance.role,
    };

EndSessionResponse _$EndSessionResponseFromJson(Map<String, dynamic> json) =>
    EndSessionResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      summary: json['summary'] == null
          ? null
          : EndSessionSummary.fromJson(json['summary'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EndSessionResponseToJson(EndSessionResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'summary': instance.summary,
    };

EndSessionSummary _$EndSessionSummaryFromJson(Map<String, dynamic> json) =>
    EndSessionSummary(
      endedAt: json['ended_at'] as String?,
    );

Map<String, dynamic> _$EndSessionSummaryToJson(EndSessionSummary instance) =>
    <String, dynamic>{
      'ended_at': instance.endedAt,
    };

AttendanceResponse _$AttendanceResponseFromJson(Map<String, dynamic> json) =>
    AttendanceResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      sessionTitle: json['session_title'] as String,
      summary:
          AttendanceSummary.fromJson(json['summary'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>)
          .map((e) => AttendanceStudent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AttendanceResponseToJson(AttendanceResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'session_title': instance.sessionTitle,
      'summary': instance.summary,
      'data': instance.data,
    };

AttendanceSummary _$AttendanceSummaryFromJson(Map<String, dynamic> json) =>
    AttendanceSummary(
      totalStudents: (json['total_students'] as num).toInt(),
      activeNow: (json['active_now'] as num).toInt(),
    );

Map<String, dynamic> _$AttendanceSummaryToJson(AttendanceSummary instance) =>
    <String, dynamic>{
      'total_students': instance.totalStudents,
      'active_now': instance.activeNow,
    };

AttendanceStudent _$AttendanceStudentFromJson(Map<String, dynamic> json) =>
    AttendanceStudent(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$AttendanceStudentToJson(AttendanceStudent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
