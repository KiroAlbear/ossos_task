import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ossos_task/imports.dart';

class TestFeaturePage extends BaseStatefulWidget {
  const TestFeaturePage({super.key});

  @override
  State<TestFeaturePage> createState() => _TestFeaturePageState();
}

class _TestFeaturePageState extends BaseStatefullState<TestFeaturePage> {
  final TextEditingController _testController = TextEditingController();

  @override
  PreferredSizeWidget? appBar() {
    return CustomAppar(title: "title", withBackArrow: false);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<TestFeatureBloc>(context).add(getTestFeatureEvent(1));
    });
    super.initState();
  }

  @override
  Widget getBody(BuildContext context) {
    return BaseBloc<TestFeatureBloc, BaseBlocState, TestFeatureState>(
      builder: (TestFeatureState state) {
        return Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                label: "Email",
                hintText: "Enter your email",
                controller: _testController,
              ),
              12.ph,
              CustomElevatedButton(
                onPressed: () {},
                child: Text("Submit Complaint"),
              ),
            ],
          ),
        );
      },
    );
  }
}
