class Qdl < Formula
  desc "Flash images to Qualcomm EDL devices"
  homepage "https://github.com/linux-msm/qdl"
  url "https://github.com/linux-msm/qdl/archive/refs/tags/v2.6.tar.gz"
  sha256 "56d9554457651beb82237cc49827b2b3ab6999c8bad54aa3af3a89f34c70a2d9"
  license "BSD-3-Clause"

  head "https://github.com/linux-msm/qdl.git"

  depends_on "help2man" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"
  depends_on "libxml2"
  depends_on "libzip"

  def install
    # v2.6 uses GNU Make; HEAD uses Meson after the build system migration
    if build.head?
      system "meson", "setup", "build",
             "-DVERSION=#{version}",
             *std_meson_args
      system "meson", "compile", "-C", "build"
      system "meson", "compile", "manpages", "-C", "build"
      system "meson", "install", "-C", "build"
    else
      system "make", "VERSION=#{version}", "manpages"
      system "make", "VERSION=#{version}", "install", "prefix=#{prefix}"
      man1.install Dir["*.1"]
    end
  end

  test do
    system bin/"qdl", "--version"
  end
end
