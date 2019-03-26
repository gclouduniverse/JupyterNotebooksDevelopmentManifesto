# Jupyter Notebooks Development Manifesto

*this repository WILL eventually contain both: the maifesto and the tools that help to implement each of the items from the manifesto*

Jupyter Notebook is a relatively young tool, it does not yet have best engineering practices. Like with any other tools if it is used by one-person-team on a small project for experimentation, very likely you do not need any eng practices (I have tons of small Python scripts that neither covered with tests nor have any CI/CD systems). However, if you using Jupyter Notebooks in a bigger project with many engineers it is hard to miss that this tool is not yet fully ready for the full-scale productional use.

This manifesto combines things that I believe need to be implemented in order to solve some of the main pain points and make the life of any developer who is using Jupyter tools simpler and better.

This is a live document, it will be updated as we go, therefore at some point, you will see link on the GitHub page where I will post it in order to enable anyone to participate in the discussion.

Here we go.

1. **(Jupyter Notebook is) just a tool.** Therefore all the generic best practices of software development should apply to it. This one is probably the most important part. Jupyter Notebook is like, for example, an Android Studio (or any other development tool), yes there are some best practices for the Android developers, however overall it would be strange to say that generic eng best practices do not apply to Android developers.
1. **(Jupyter Notebooks need to have) version control system integration.** In order to un-block effective use of version control system like git, there should be tooling well integrated into the Jupyter UI that allows to effectively resolve conflicts for the notebook, view history of each cell, been able to commit/push particular parts of the notebook right from the cell.
1. **(Jupyter Notebooks should be) self-contained.** There should be a way to determine the environment that is needed for the Notebook to be executed. For example, if the notebook requires Deep Learning VM M19 with some additional package installed there should be a way to determine this from the notebook itself.
1. **(Each change to a Jupyter Notebook should be checked by a) continuous integration system.**
1. **Parameterized Notebooks**. There should be a way to pass input arguments to Jupyter Notebooks.
1. **Continues delivery**. Each version of a Jupyter Notebook that has passed all the tests should be used to automatically generate a new artifact and deploy it.
1. **Log all experiments automatically** Every time you try to train a model, various metadata about the training session should be automatically logged.  You'll want to keep track of things like: the model structure, it's hyper parameters, the data source, the results, training time, etc. This will help you remember past results and you won't find yourself wondering "did I already try running this experiment"?

Just imagine the world where you can start pre-commit checks of your changes that you have done to a notebook directly from the Jupyter Lab UI and immediately got a notification that Notebook now is not runnable when cells are executed one by one with a stack trace of a problem. Or, what about starting 10 background execution of the notebook with 10 different variables to see which arguments are better working, before committing? All these and much more absolutely possible if you following this manifesto rules.
