@Component
export struct Spin {
  @State isLoading: boolean = false;
  delay: number = 0;
  timer: number = null;

  aboutToAppear() {
    this.timer = setTimeout(() => {
      this.isLoading = true;
    }, this.delay);
  }

  aboutToDisappear() {
    clearTimeout(this.timer);
  }

  build() {
    Row() {
      if (this.isLoading) {
        LoadingProgress()
          .color($r('app.color.grey_loading_progress_color'))
          .height($r('app.float.loading_progress_size'))
          .width($r('app.float.loading_progress_size'))
      }
    }
    .height($r('app.float.loading_progress_size'))
    .width($r('app.float.loading_progress_size'))
  }
}