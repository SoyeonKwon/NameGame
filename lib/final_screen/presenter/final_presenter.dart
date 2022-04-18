import '../views/final_view.dart';
import '../viewmodel/final_viewmodel.dart';

class FinalPresenter {

  set setFinalView(FinalView value){}

}

class BasicFinalPresenter implements FinalPresenter{
  //SetDetailsViewModel _viewModel = SetDetailsViewModel();
  FinalView _view = FinalView();

  BasicFinalPresenter() {
    //this._viewModel = _viewModel;
  }

  // void _loadUnit() async {
  //   loadRecentDetails();
  // }

  @override
  set setFinalView(FinalView value) {
    _view = value;
  }

}