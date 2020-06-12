import 'package:client/ui/shared/size_fit.dart';

extension IntFit on int {
  double get px {
    return WYSizeFit.setPx(this.toDouble());
  }

  double get rpx {
    return WYSizeFit.setRpx(this.toDouble());
  }
}