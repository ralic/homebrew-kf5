class Kf5Okular < Formula
  homepage "https://okular.kde.org"
  url "https://download.kde.org/stable/applications/17.08.0/src/okular-17.08.0.tar.xz"
  sha256 "cf2b5e372edd27ab847309a5f1a1e7f99fab5f759ffe1361b826ca448294f039"

  head "git://anongit.kde.org/okular.git"

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt"

  depends_on "zlib"
  depends_on "freetype"

  depends_on "haraldf/kf5/kf5-kactivities"
  depends_on "haraldf/kf5/kf5-karchive"
  depends_on "haraldf/kf5/kf5-kbookmarks"
  depends_on "haraldf/kf5/kf5-kcompletion"
  depends_on "haraldf/kf5/kf5-kconfig"
  depends_on "haraldf/kf5/kf5-kconfigwidgets"
  depends_on "haraldf/kf5/kf5-kcoreaddons"
  depends_on "haraldf/kf5/kf5-kdbusaddons"
  depends_on "haraldf/kf5/kf5-kdoctools"
  depends_on "haraldf/kf5/kf5-khtml"
  depends_on "haraldf/kf5/kf5-kiconthemes"
  depends_on "haraldf/kf5/kf5-kio"
  depends_on "haraldf/kf5/kf5-kjs"
  depends_on "haraldf/kf5/kf5-kparts"
  depends_on "haraldf/kf5/kf5-kpty"
  depends_on "haraldf/kf5/kf5-threadweaver"
  depends_on "haraldf/kf5/kf5-kwallet"
  depends_on "haraldf/kf5/kf5-kwindowsystem"

  def patches
    DATA
  end

  def install
    args = std_cmake_args

    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"

    # mkdir_p "#{Etc.getpwuid.dir}/Library/Application Support/okular"
    # system "ln", "-sf", "#{HOMEBREW_PREFIX}/share/icons/breeze/breeze-icons.rcc", "#{Etc.getpwuid.dir}/Library/Application Support/okular/icontheme.rcc"
  end

  def caveats; <<-EOS.undent
    You need to take some manual steps in order to make this formula work:
      mkdir -p "~/Library/Application Support/okular"
      ln -sf "#{HOMEBREW_PREFIX}/share/icons/breeze/breeze-icons.rcc" "~/Library/Application Support/okular/icontheme.rcc"
    EOS
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 7537220..5fef3d7 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -190,7 +190,7 @@ generate_export_header(okularcore BASE_NAME okularcore EXPORT_FILE_NAME "${CMAKE

 # Special handling for linking okularcore on OSX/Apple
 IF(APPLE)
-    SET(OKULAR_IOKIT "-framework IOKit" CACHE STRING "Apple IOKit framework")
+    SET(OKULAR_IOKIT "-framework CoreFoundation -framework CoreGraphics -framework IOKit" CACHE STRING "Apple IOKit framework")
 ENDIF(APPLE)

 target_link_libraries(okularcore
diff --git a/core/utils.cpp b/core/utils.cpp
index c9bfc2d..b8c955f 100644
--- a/core/utils.cpp
+++ b/core/utils.cpp
@@ -134,7 +134,7 @@ QSizeF Utils::realDpi(QWidget* widgetOnScreen)
         return err;
     }

-double Utils::realDpiX()
+static double realDpiX()
 {
     double x,y;
     CGDisplayErr err = GetDisplayDPI( CGDisplayCurrentMode(kCGDirectMainDisplay),
@@ -144,7 +144,7 @@ double Utils::realDpiX()
     return err == CGDisplayNoErr ? x : 72.0;
 }

-double Utils::realDpiY()
+static double realDpiY()
 {
     double x,y;
     CGDisplayErr err = GetDisplayDPI( CGDisplayCurrentMode(kCGDirectMainDisplay),
