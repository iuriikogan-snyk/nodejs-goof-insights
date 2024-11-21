const { DataSource, EntitySchema } = require("typeorm");
const Users = require("./entity/Users");

// Define a new data source
const AppDataSource = new DataSource({
  type: "mysql",
  host: process.env.MYSQL_URI,
  port: 3306,
  username: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
  synchronize: true,
  logging: true,
  entities: [
    new EntitySchema(Users)
  ],
});

AppDataSource.initialize()
  .then(async (dataSource) => {
    console.log("Data Source has been initialized!");

    const repo = dataSource.getRepository("Users");

    console.log("Seeding 2 users to MySQL users table: Liran (role: user), Simon (role: admin)");

    const inserts = [
      repo.insert({
        name: "Liran",
        address: "IL",
        role: "user",
      }),
      repo.insert({
        name: "Simon",
        address: "UK",
        role: "admin",
      }),
      repo.insert({
        name: "Iurii",
        address: "RO",
        role: "admin",
      }),
    ];

    await Promise.all(inserts);
    console.log("Users have been successfully seeded!");
  })
  .catch((err) => {
    console.error("Failed connecting and seeding users to the MySQL database");
    console.error(err);
  });
