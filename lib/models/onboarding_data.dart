class OnBoarding {
  String title;
  String subtitle;
  String image;

  OnBoarding({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}

List<OnBoarding> onboardingContents = [
  OnBoarding(
    title: 'Chào mừng đến với \n Clean Service',
    subtitle:
    'Ứng dụng thông minh giúp gắn kết khách hàng và công tác viên nhằm đem lại chất lượng dịch vụ tốt nhất.',
    image: 'assets/img/img1.png',
  ),
  OnBoarding(
    title: 'Dịch vụ chuyên nghiệp',
    subtitle:
    'Cộng tác viên có trình độ chuyên môn cao.Thuật toán thông minh tự động phù hợp với yêu cầu dịch vụ.',
    image: 'assets/img/img2.png',
  ),
  OnBoarding(
    title: 'An toàn tuyệt đối ',
    subtitle:
    'Thông tin được bảo mật tuyệt đối. Cộng tác viên làm việc dưới sự giám sát và điều hành trực tiếp từ Clean Service',
    image: 'assets/img/splash.png',
  ),

];