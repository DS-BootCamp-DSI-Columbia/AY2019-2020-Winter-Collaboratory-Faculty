This page provides brief instructions for installing the software on your laptops that is needed for the Bayesian Modeling bootcamp.

Although you can use Python, if you have any experience with R, it is recommended to use R for this bootcamp 
because more functionality is available and the bootcamp examples use R. But if you have no experience with
R and some experience with Python, you can use Python to get as much as you can out of the bootcamp.

# Instructions for R (recommended)

First, install the rstan R package from CRAN in the usual way

```{r}
install.packages("rstan", dependencies = TRUE)
```

However, that alone is insufficient for the rstan package to work properly because you also need a C++ toolchain
in order to compile Stan programs. The installation of the C++ toolchain depends on your operating system.

* __Windows__: Visual Studio (VS) does not work (well) with R packages, so you need to install an open-source
  C++ toolchain that does. In R, execute `pkgbuild::has_build_tools(debug = TRUE)` and a box will pop up asking you
  if you would like to install "RTools", which includes the C++ toolchain. Click "yes" and wait for a little
  bit while RTools installs in the background. Then, you should be good to go.
* __Mac__: 
  - If your operating system is Catalina (which is the most recent version of the Mac OS X operating system),
  the procedure is more involved because Apple instituted a new policy on January 1, 2020 that makes it more
  difficult to install the C++ toolchain that works best with R packages. Go to this 
  [webpage](https://thecoatlessprofessor.com/programming/cpp/r-compiler-tools-for-rcpp-on-macos/)
  and find the section halfway down the page entitled "Manual Install Guide". Follow the steps from there to
  the bottom of the webpage.
  - If your operating system is pre-Catalina, download the Mac version of RTools from 
  [here](https://github.com/rmacoslib/r-macos-rtools/releases/download/v3.2.2/macos-rtools-3.2.2.pkg).
  Follow the instructions, and then you should be good to go.
* __Linux__: If you use Linux, you probably already have a C++ toolchain, most likely based on `g++` or `clang++`,
  although your executable may have a suffix like `g++-8` or `clang++-9`. If not, you will have to install one
  using your distribution's package manager.
  
  If you use a recent version of Debian, Ubuntu, or one of its derivatives, you can install the rstan package via 
  `sudo apt install r-cran-rstan`. Otherwise, go to this 
  [webpage](https://github.com/stan-dev/rstan/wiki/Installing-RStan-on-Linux#c-toolchain-configuration)
  for a few lines of code that will configure your environment properly to use Stan. At that point, you
  should be able to install the rstan package from source via CRAN.

Online access to a computer with rstan installed will be provided for anyone who cannot install the rstan
package on their laptops, but please try to install rstan on your laptops first. That way if there are any
problems, we can try to fix them before the bootcamp starts or during lunch.

# Instructions for Python

Follow the instructions on this [webpage](https://pystan.readthedocs.io/en/latest/installation_beginner.html).
