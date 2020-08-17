import 'package:get/get.dart';
import 'package:librebook/app/locator.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/models/book_search_detail_model.dart';
import 'package:librebook/services/book_service.dart';

class SearchResultController extends GetxController {
  var isLoading = false.obs;
  Rx<BookSearchDetail> bookSearchDetail ;
  final _bookService = locator<BookService>();
  RxList<Book> listBook = RxList<Book>();

  setLoading(bool isLoading) {
    this.isLoading.value = isLoading;
  }

  setBookSearchDetail(BookSearchDetail bookSearchDetail) {
    this.bookSearchDetail = bookSearchDetail.obs;
    listBook = bookSearchDetail.listBook.obs;
  }

  setBookSearchDetailNew(BookSearchDetail bookSearchDetail) {
    this.bookSearchDetail = bookSearchDetail.obs;
    listBook = bookSearchDetail.listBook.obs;
  }

  checkLastPage() {
    print('currentPage: ' + bookSearchDetail.value.currentPage.toString());
    print('lastPage: ' + bookSearchDetail.value.lastPage.toString());
    if (bookSearchDetail.value.currentPage >= bookSearchDetail.value.lastPage) {
      return;
    }
  }

  Future loadData(String query) async {
    setLoading(true);
    checkLastPage();
    Stopwatch stopwatch = new Stopwatch()..start();
    print('loaddataTrigger');
    // Delay to prevent server exception
    await Future.delayed(Duration(seconds: 2));
    final page = this.bookSearchDetail.value.currentPage + 1;
    try {
      final nextBookSearchDetail = await _bookService.findGeneral(query, page);
      setBookSearchDetail(nextBookSearchDetail);
    } catch (e) {
      print('exception bangs');
    }
    setLoading(false);
    print(
        'loadData(page: ${page.toString()}) executed in ${stopwatch.elapsed}');
  }

  Future onRefreshData(String query) async {
    setLoading(true);
    final nextBookSearchDetail = await _bookService.findGeneral(query, 1);
    setBookSearchDetailNew(nextBookSearchDetail);
    setLoading(false);
  }
}