import 'package:client/ui/shared/size_fit.dart';

extension DoubleFit on double {
  double get px {
    return WYSizeFit.setPx(this);
  }

  double get rpx {
    return WYSizeFit.setRpx(this);
  }
}
