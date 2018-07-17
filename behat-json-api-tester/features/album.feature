Feature: Provide a consistent standard JSON API endpoint

  In order to build interchangeable front ends
  As a JSON API developer
  I need to allow Create, Read, Update, and Delete functionality

  Background:
    Given there are Albums with the following details:
      | title                              | track_count | release_date              |
      | some fake album name               | 12          | 2020-01-08T00:00:00+00:00 |
      | another great album                | 9           | 2019-01-07T23:22:21+00:00 |
      | now that's what I call Album vol 2 | 23          | 2018-02-06T11:10:09+00:00 |

  Scenario: Can get a single Album
    Given I request "/album/1" using HTTP GET
    Then the response code is 200
    And the response body contains JSON:
    """
    {
      "id": 1,
      "title": "some fake album name",
      "track_count": 12,
      "release_date": "2020-01-08T00:00:00+00:00"
    }
    """

  Scenario: Can get a collection of Albums
    Given I request "/album" using HTTP GET
    Then the response code is 200
    And the response body contains JSON:
    """
    [
      {
        "id": 1,
        "title": "some fake album name",
        "track_count": 12,
        "release_date": "2020-01-08T00:00:00+00:00"
      },
      {
        "id": 2,
        "title": "another great album",
        "track_count": 9,
        "release_date": "2019-01-07T23:22:21+00:00"
      },
      {
        "id": 3,
        "title": "now that's what I call Album vol 2",
        "track_count": 23,
        "release_date": "2018-02-06T11:10:09+00:00"
      }
    ]
    """

  Scenario: Can add a new Album
    Given the request body is:
      """
      {
        "title": "Awesome new Album",
        "track_count": 7,
        "release_date": "2030-12-05T01:02:03+00:00"
      }
      """
    When I request "/album" using HTTP POST
    Then the response code is 201

  Scenario: Can update an existing Album - PUT
    Given the request body is:
      """
      {
        "title": "Renamed an album",
        "track_count": 9,
        "release_date": "2019-01-07T23:22:21+00:00"
      }
      """
    When I request "/album/2" using HTTP PUT
    Then the response code is 204

  Scenario: Can update an existing Album - PATCH
    Given the request body is:
      """
      {
        "track_count": 10
      }
      """
    When I request "/album/2" using HTTP PATCH
    Then the response code is 204

  Scenario: Can delete an Album
    Given I request "/album/3" using HTTP GET
    Then the response code is 200
    When I request "/album/3" using HTTP DELETE
    Then the response code is 204
    When I request "/album/3" using HTTP GET
    Then the response code is 404