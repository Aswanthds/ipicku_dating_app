import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';

class AgeSelectionWidget extends StatefulWidget {
  const AgeSelectionWidget({super.key});

  @override
  State<AgeSelectionWidget> createState() => _AgeSelectionWidgetState();
}

class _AgeSelectionWidgetState extends State<AgeSelectionWidget> {
  int minAge = 18;
  int maxAge = 50;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 18.0,
              top: 10,
              bottom: 10,
            ),
            child: Text(
              "Age Preference",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (minAge > 18) {
                      minAge--;
                    }
                  });
                },
                disabledColor: AppTheme.grey,
                color: minAge > 18 ? AppTheme.blue : AppTheme.grey,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('$minAge'),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    if (minAge < maxAge) {
                      minAge++;
                    }
                  });
                },
                disabledColor: AppTheme.grey,
                color: minAge < maxAge ? AppTheme.blue : AppTheme.grey,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (maxAge > minAge) {
                      maxAge--;
                    }
                  });
                },
                disabledColor: AppTheme.grey,
                color: maxAge > minAge ? AppTheme.blue : AppTheme.grey,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('$maxAge'),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    if (maxAge < 50) {
                      maxAge++;
                    }
                  });
                },
                disabledColor: AppTheme.grey,
                color: maxAge < 50 ? AppTheme.blue : AppTheme.grey,
              ),
            ],
          ),
          TextButton(
              onPressed: () {
                BlocProvider.of<FirebaseDataBloc>(context).add(
                    AddUseFieldData(fieldName: 'minAge', newValue: minAge));
                BlocProvider.of<FirebaseDataBloc>(context).add(
                    AddUseFieldData(fieldName: 'maxAge', newValue: maxAge));
                Navigator.pop(context);
              },
              child: const Text("Submit")),
        ],
      ),
    );
  }
}
