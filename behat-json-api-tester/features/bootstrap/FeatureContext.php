<?php

use Behat\Behat\Context\Context;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;

/**
 * Defines application features from the specific context.
 */
class FeatureContext implements Context
{
    private $apiContext;

    /**
     * Initializes context.
     *
     * Every scenario gets its own context instance.
     * You can also pass arbitrary arguments to the
     * context constructor through behat.yml.
     */
    public function __construct()
    {
    }

    /** @BeforeScenario */
    public function gatherContexts(BeforeScenarioScope $scope)
    {

        $this->apiContext = $scope->getEnvironment()->getContext(
            \Imbo\BehatApiExtension\Context\ApiContext::class
        );
    }

    /**
     * @BeforeScenario
     */
    public function cleanUpDatabase()
    {
        $host = '0.0.0.0';
        $db   = 'basic_api';
        $port = 3306;
        $user = 'dbuser';
        $pass = 'dbpassword';
        $charset = 'utf8mb4';

        $dsn = "mysql:host=$host;port=$port;dbname=$db;charset=$charset";
        $opt = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];
        $pdo = new PDO($dsn, $user, $pass, $opt);

        $pdo->query('TRUNCATE album');
    }

    /**
     * @Given there are Albums with the following details:
     */
    public function thereAreAlbumsWithTheFollowingDetails(TableNode $albums)
    {
        foreach ($albums->getColumnsHash() as $album) {

            $this->apiContext->setRequestBody(
              json_encode($album)
            );

            $this->apiContext->requestPath(
                '/album',
                'POST'
            );

//            exit(var_dump($album));
        }
    }

}
