import 'package:flutter/widgets.dart';

width(context) => MediaQuery.of(context).size.width;
height(context) => MediaQuery.of(context).size.height;

const double padding0 = 0;
const double padding1 = 5;
const double padding2 = 10;
const double padding3 = 15;
const double padding4 = 20;
const double padding5 = 25;

const EdgeInsets paddingAll0 = EdgeInsets.all(padding0);
const EdgeInsets paddingAll1 = EdgeInsets.all(padding1);
const EdgeInsets paddingAll2 = EdgeInsets.all(padding2);
const EdgeInsets paddingAll3 = EdgeInsets.all(padding3);
const EdgeInsets paddingAll4 = EdgeInsets.all(padding4);
const EdgeInsets paddingAll5 = EdgeInsets.all(padding5);

const EdgeInsets paddingSymmetricHorizontal1 =
    EdgeInsets.symmetric(horizontal: padding1, vertical: padding0);
const EdgeInsets paddingSymmetricHorizontal2 =
    EdgeInsets.symmetric(horizontal: padding2, vertical: padding0);
const EdgeInsets paddingSymmetricHorizontal3 =
    EdgeInsets.symmetric(horizontal: padding3, vertical: padding0);
const EdgeInsets paddingSymmetricHorizontal4 =
    EdgeInsets.symmetric(horizontal: padding4, vertical: padding0);
const EdgeInsets paddingSymmetricHorizontal5 =
    EdgeInsets.symmetric(horizontal: padding5, vertical: padding0);

const EdgeInsets paddingSymmetricVertical1 =
    EdgeInsets.symmetric(horizontal: padding0, vertical: padding1);
const EdgeInsets paddingSymmetricVertical2 =
    EdgeInsets.symmetric(horizontal: padding0, vertical: padding2);
const EdgeInsets paddingSymmetricVertical3 =
    EdgeInsets.symmetric(horizontal: padding0, vertical: padding3);
const EdgeInsets paddingSymmetricVertical4 =
    EdgeInsets.symmetric(horizontal: padding0, vertical: padding4);
const EdgeInsets paddingSymmetricVertical5 =
    EdgeInsets.symmetric(horizontal: padding0, vertical: padding5);
