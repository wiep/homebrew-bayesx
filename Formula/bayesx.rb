class BayesXSvnStrategy < SubversionDownloadStrategy

  def fetch_repo(target, url, revision = nil, ignore_externals = false)
    # Use "svn update" when the repository already exists locally.
    # This saves on bandwidth and will have a similar effect to verifying the
    # cache as it will make any changes to get the right revision.
    args = []

    if revision
      ohai "Checking out #{@ref}"
      args << "-r" << revision
    end

    args << "--ignore-externals" if ignore_externals

    args << "--trust-server-cert-failures=expired"
    args << "--non-interactive"
    args << "--username"
    args << "anonymous"
    args << "--password"
    args << ""

    if target.directory?
      system_command!("svn", args: ["update", *args], chdir: target.to_s)
    else
      system_command!("svn", args: ["checkout", url, target, *args])
    end
  end
end

class Bayesx < Formula
  homepage "http://www.bayesx.org"
  url "http://www.uni-goettingen.de/de/document/download/90444656aedaa8123a12ac806b17bc48.zip/bayesxsource_3_0_1.zip"
  version "3.0.1"
  sha256 "fd4b2321b0aed78d4dab70a25d3deb609ef5e5cbfb37317540b63b153c4e0b38"

  head "https://svn.gwdg.de/svn/bayesx/trunk/", :using => BayesXSvnStrategy

  depends_on "cmake" => :build
  depends_on "gsl"
  depends_on "readline"

  option "with-java", "Enable java support"

  def install
    args = ["-DWithoutDefaultOs=On"] + std_cmake_args
    unless build.with? "java"
      args.push("-DWithoutJava=On")
    end
    system "cmake", ".", *args
    system "make", "bayesx"
    bin.install "bayesx"

    if build.head?
      prefix.install "sourcecode/LICENSE"
    else
      prefix.install "LICENSE"
    end
  end

  test do
    # TODO
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test bayesx`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
