require "formula"

class Kf5Kinit < Formula
  url "http://download.kde.org/stable/frameworks/5.38/kinit-5.38.0.tar.xz"
  sha256 "ae49e0a3cf8a86868afb57bfd820c65be60939e4a79d39e54608fcc9f307914c"
  homepage "http://www.kde.org/"

  head "git://anongit.kde.org/kinit.git"

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt"
  depends_on "haraldf/kf5/kf5-kio"

  patch :DATA

  def install
    args = std_cmake_args

    system "cmake", ".", *args
    system "make", "install"

    # mkdir_p "#{HOMEBREW_PREFIX}/lib/kde5/libexec"
    # ln_sf "#{lib}/kde5/libexec/klauncher", "#{HOMEBREW_PREFIX}/lib/kde5/libexec/"

    prefix.install "install_manifest.txt"
  end

  def caveats; <<-EOS.undent
    You need to take some manual steps in order to make this formula work:
      mkdir -p "#{HOMEBREW_PREFIX}/lib/kde5/libexec"
      ln -sf "#{lib}/kde5/libexec/klauncher" "#{HOMEBREW_PREFIX}/lib/kde5/libexec/"
    EOS
  end
end

__END__
diff --git a/src/kdeinit/CMakeLists.txt b/src/kdeinit/CMakeLists.txt
index f00dd77..6c5f593 100644
--- a/src/kdeinit/CMakeLists.txt
+++ b/src/kdeinit/CMakeLists.txt
@@ -3,6 +3,7 @@ if (WIN32)
   set(kdeinit_LIBS psapi)
 elseif (APPLE)
   set(kdeinit_SRCS kinit.cpp kinit_mac.mm proctitle.cpp ../klauncher_cmds.cpp )
+  set_source_files_properties(kinit_mac.mm PROPERTIES COMPILE_DEFINITIONS QT_NO_EXCEPTIONS)
   set(kdeinit_LIBS "")
 else ()
   set(kdeinit_SRCS kinit.cpp proctitle.cpp ../klauncher_cmds.cpp )
