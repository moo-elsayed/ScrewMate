import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skru_mate/core/helpers/extentions.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({
    super.key,
    required this.name,

    this.onDelete,
  });

  final String name;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Delete Confirmation', style: GoogleFonts.lato()),
      content: Text.rich(
        TextSpan(
          style: GoogleFonts.lato(),
          children: [
            const TextSpan(text: 'Are you sure you want to delete '),
            TextSpan(
              text: name,
              style: GoogleFonts.lato(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: ' ? This action cannot be undone.'),
          ],
        ),
      ),

      actions: [
        CupertinoDialogAction(
          child: Text('Cancel', style: GoogleFonts.lato()),
          onPressed: () {
            context.pop();
          },
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: onDelete,
          child: Text('Delete', style: GoogleFonts.lato()),
        ),
      ],
    );
  }
}
