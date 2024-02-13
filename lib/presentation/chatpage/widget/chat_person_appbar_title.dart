import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/chatpage/widget/chat_person.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessagePersonAppBarTitle extends StatelessWidget {
  const MessagePersonAppBarTitle({
    super.key,
    required this.widget,
    required this.lastActive,
  });

  final ChatPagePerson widget;
  final DateTime lastActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            (!widget.currentUser?['blocked'] &&
                    widget.currentUser?['done_by'] ==
                        widget.selectedUser?['uid'])
                ? CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage(widget.selectedUser?['photoUrl']),
                  )
                : CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.orange,
                    child: Center(
                        child: Text(
                      widget.selectedUser?['name'][0],
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    )),
                  ),
            (widget.selectedUser?['status'])
                ? const Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: AppTheme.green,
                      radius: 5,
                    ),
                  )
                : const SizedBox()
          ],
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.selectedUser?['name'],
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20),
            ),
            (widget.currentUser?['blocked'] &&
                    widget.currentUser?['done_by'] ==
                        widget.selectedUser?['uid'])
                ? Text(
                    '',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 9),
                  )
                : (widget.selectedUser?['status'] == false &&
                        lastActive != DateTime.now())
                    ? Text(
                        'Active ${timeago.format(lastActive, allowFromNow: true, clock: DateTime.now())}',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    : Text(
                        'Active now',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.green, fontWeight: FontWeight.bold),
                      )
          ],
        ),
      ],
    );
  }
}
