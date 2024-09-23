# rebase-labs 0.0.1

## origin
re:bLABSe is the result of a bootcamp with the goal of building a web application without using Rails.

## function
The application focuses on the process of importing CSV data related to medical exams. The import process and the visualization of the imported data, can be done through an HTML interface, API endpoints, and a Ruby script.

## installation and startup

1. Install docker compose following the instructions at
   - https://docs.docker.com/compose/install/
2. Make sure docker is running with `docker ps`
   - If it is not, run `sudo systemctl start docker`
   - If any problems occur, check if your system user has sudo permission.
   - You can authorize your user with `sudo usermod -aG docker $USER`
3. Clone the repository with
   - `sudo git clone https://github.com/GyodaiDDA/rebase-labs.git`
4. Access the `rebase-labs/app/` directory
5. In the terminal, use `docker compose up`
   
## web interface
    Once the project is live, the html interface will be available at http://localhost:4567.

### - import
*To import the data, click **Import**, select the `data1.csv` file located in `rebase-labas/app/csv` and click **Upload file**.

    The import job is asynchronous, so it may take some time until you can visualize the imported data.*

### - see all data
*To do this, click the button **"See all data"**. Each result will be represented by the token and the exam date. By clicking on each result, you can view more details about the exam.*

### - search
*To search for tokens, fill in the input field and click **Search**. The token search can receive one or more elements separated by commas and no spaces.*

    Example: **5UP5FA,IWH46D,AAA111**

*The results for valid tokens will be shown. Tokens that do not correspond to a record in the database will be ignored.*


## import script

In the app folder, the import script `ruby import_from_csv.rb` can be used directly to import the data from the `data1.csv` file.


## endpoints

The endpoints are listed below:

   - **/tests**
     - returns all exam records found in the database
   - **/tests/{tokens}**
     - returns the details of one or more exams
   - **/import**
     - receives POST to import a csv file


## folders

- The central block of the application is formed by `server.rb` and `config.ru`, both in the **app** folder of the *backend* container.
- The folders follow the following structure:
- **/public** - contains the files related to the frontend/web interface
- **/csv** - is the default folder for the CSV files `test-file.csv` and `data1.csv` to be imported via script
- **/jobs** - contains two asynchronous jobs responsible for importing the files and cleaning the temporary files that are saved in the same folder.
- **/queries** - contains sql files used by several methods
- **/helpers** - contains specialized methods for database operations, reading csv files and delivering data to endpoints
- **/config** contains only database.yml with environment configuration

## data structure
- For the csv to be importable, it must follow this structure:
  - cpf; patient name; patient email; patient date of birth; patient address/street; patient city; patient state; doctor's crm; doctor's crm state; doctor's name; doctor's email; exam result token; exam date; exam type; exam type limits; exam type result

- in the database this structure is separated into 5 tables:
  - patients
  - doctors
  - exams
  - test_types
  - test_results
  
## automated tests

The rspec gem is installed and tests for the backend processes are implemented. To run the tests, run `rspec` in the `rebase-labs/app/` directory.


## versions and gems
All gems and their versions can be found in `Gemfile`. Docker compose will always use the latest version of the **ruby**, **postgres** and **redis** images.


## next steps
*In this same directory, you can find the TODO.md file with notes for future development of the application.*

## thanks

*Thanks to rebase and the invaluable help of my fellow CampusCoders from T11.*
o/

#### contact: rodrigo.gyodai@gmail.com
