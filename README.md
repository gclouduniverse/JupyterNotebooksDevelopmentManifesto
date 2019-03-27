# Jupyter Notebooks Development Manifesto

*This repository WILL eventually contain both: the maifesto and the tools that help to implement each of the items from the manifesto.*

*Note: This is a live document, it will be updated as we go, therefore at some point, you will see link on the GitHub page where I will post it in order to enable anyone to participate in the discussion.*

Jupyter Notebook is a relatively young tool, it does not yet have best engineering practices. Like with any other tools if it is used by one-person-team on a small project for experimentation, very likely you do not need any eng practices (I have tons of small Python scripts that neither covered with tests nor have any CI/CD systems). However, if you using Jupyter Notebooks in a bigger project with many engineers it is hard to miss that this tool is not yet fully ready for the full-scale productional use.

This manifesto combines things that I believe need to be implemented in order to solve some of the main pain points and make the life of any developer who is using Jupyter tools simpler and better.

Often times best practices are shared across multiple industries since the fundamentals remain the same.  Similarly, data scientists, ML researchers, and developers using Jupyter Notebooks should carry over the best practices already established by the fields of computer science and scientific research.  

The following best practices are adaptations of the ones established by those communities, highlighting principles that have withstood the test of time.

1.  **Follow established software development best practices.** This one is probably the most important. Jupyter Notebook is just a tool, a new development environment for writing code. All the generic best practices of software development still apply to it.  
1. **Version control your Notebooks.** In order to un-block effective use of version control system like git, there should be tooling well integrated into the Jupyter UI that allows to effectively resolve conflicts for the notebook, view history of each cell, been able to commit/push particular parts of the notebook right from the cell.
1. **Reproducible Notebooks(Self-contained Notebooks).**  The notebooks should be made in a way that anyone else can take that notebook, rerun it with the same inputs, and get the same outputs.  This involves multiple details, some of which the next best practice elaborates on: The notebook shold be executable from top to bottom, the notebook should contain the information requried to setup the correct environment.
      1. *Self-contained Notebooks*. This is critical for reproducibility. There should be a way to determine & recreate the environment required for the Notebook to be executed. For example, if the notebook requires GCP's Deep Learning VM M19 with some additional packages installed there should be a way to determine this from the notebook itself. Without self-contained notebooks it will be very hard for anyone else to reproduce your notebook. You yourself may find it difficult to run your notebook on a different computer if there isn't a good record of what your notebook depends on
1. **Continuous Integration (CI) pipeline for Notebooks** Each change to a Jupyter Notebook should be validated by a continuous integration system before being checked into source control.
1. **Parameterized Notebooks**. There should be a way to pass input arguments to Jupyter Notebooks.
1. **Continuous Delivery (CD)** Each version of a Jupyter Notebook that has passed all the tests should be used to automatically generate new artifact and deploy it to staging and production environments.
1. **Log all experiments automatically** Every time you try to train a model, various metadata about the training session should be automatically logged.  You'll want to keep track of things like: the code you ran, it's hyper parameters, the data source, the results, training time, etc. This will help you remember past results and you won't find yourself wondering "did I already try running this experiment"?

Just imagine the world where you can start pre-commit checks of your changes that you have done to a notebook directly from the Jupyter Lab UI and immediately got a notification that Notebook now is not runnable when cells are executed one by one with a stack trace of a problem. Or, what about starting 10 background execution of the notebook with 10 different variables to see which arguments are better working, before committing? All these and much more absolutely possible if you following this manifesto rules.
