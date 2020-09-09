# Account-Batch-App
A simple application that calculates and updates the Account.Total_Amount__c field.

### Задача
1. Рассчитать Total Amount для каждого из аккаунтов в иерархии. Сумма должна включать в себя:
  * Сумму поля Amount на объекте Opportunity для всех записей относящихся к Аккаунту. При этом Opportunity Status должен быть Closed/Won.
  * Сумму Total Amount для аккаунтов находящихся ниже в иерархии.
2. Каждую неделю в пятницу вечером Total Amount на всех аккаунтах должен быть пересчитан.
3. Написать Unit tests для реализации с тестированием сценариия при котором у нас есть все 6 уровней иерархии.

### Features
Application uses:
1. Apex, SOQL queries
2. Unit-test (coverage: 100%)
3. Apex Schedule Interface
4. Apex Batchable Interface
