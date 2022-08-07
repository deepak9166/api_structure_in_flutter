import 'staus_enum.dart';

class Resource<T> {
  late Status status;
  late T data;
  late String message = "";

  Resource(this.status, this.data, this.message);

  Resource.success(this.data, this.message) {
    status = Status.success;
  }

  Resource.error(this.data, this.message) {
    status = Status.error;
  }
  Resource.expair(this.data, this.message) {
    status = Status.error;
  }

  Resource.loading(this.data, this.message) {
    status = Status.loading;
  }

  Resource.loadingEmpty() {
    status = Status.loading;
  }
}

Status getStatus(int statusCode) {
  switch (statusCode) {
    case 200:
      {
        return Status.success;
      }
    default:
      {
        return Status.error;
      }
  }
}
