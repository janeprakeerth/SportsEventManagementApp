import 'package:flutter/material.dart';
import 'pool_details.dart';

class PoolDetailsView extends StatefulWidget {
  const PoolDetailsView({Key? key}) : super(key: key);

  @override
  State<PoolDetailsView> createState() => _PoolDetailsViewState();
}

class _PoolDetailsViewState extends State<PoolDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        children: const [
          PoolDetails(
            Address: 'Kolkata',
            AgeCategory: 'sdsdsd',
            AllCategoryDetails: [],
            BreakTime: '4',
            Category: '4',
            City: 'Howrah',
            EndDate: '4',
            EndTime: '5',
            EventManagerMobileNo: '4',
            EventManagerName: '3',
            EventName: '23',
            EventType: '3',
            NoofCourts: '3',
            RegistrationCloses: '3',
            SportName: 'Badminton',
            StartDate: '2',
            StartTime: '2',
          ),
          PoolDetails(
            Address: 'Kolkata2',
            AgeCategory: '',
            AllCategoryDetails: [],
            BreakTime: '',
            Category: '',
            City: '',
            EndDate: '',
            EndTime: '',
            EventManagerMobileNo: '',
            EventManagerName: '',
            EventName: '',
            EventType: '',
            NoofCourts: '',
            RegistrationCloses: '',
            SportName: 'TT',
            StartDate: '',
            StartTime: '',
          ),
          PoolDetails(
            Address: '',
            AgeCategory: '',
            AllCategoryDetails: [],
            BreakTime: '',
            Category: '',
            City: '',
            EndDate: '',
            EndTime: '',
            EventManagerMobileNo: '',
            EventManagerName: '',
            EventName: '',
            EventType: '',
            NoofCourts: '',
            RegistrationCloses: '',
            SportName: '',
            StartDate: '',
            StartTime: '',
          )
        ],
      ),
    );
  }
}
