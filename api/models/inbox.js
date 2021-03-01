const { Sequelize, DataTypes, Model } = require('sequelize')
// const sequelize = new Sequelize('sqlite:./../database/example.db', {
// 	define: {
// 		freezeTableName: true
// 	}
// })

//const sequelize = new Sequelize('sqlite:./../database/example.db')

class Inbox extends Model {}

Inbox.init(
	{
		UpdatedInDB: {
			type: DataTypes.DATE
		},
		ReceivingDateTime: {
			type: DataTypes.DATE
		},
		Text: {
			type: DataTypes.TEXT,
			allowNull: true
		},
		SenderNumber: {
			type: DataTypes.TEXT
			// allowNull defaults to true
		},
		Coding: {
			type: DataTypes.TEXT
		},
		UDH: {
			type: DataTypes.TEXT
		},
		SMSCNumber: {
			type: DataTypes.TEXT
		},
		Class: {
			type: DataTypes.NUMBER
		},
		TextDecoded: {
			type: DataTypes.TEXT
		},
		ID: {
			type: DataTypes.NUMBER,
			primaryKey: true
		},
		Status: {
			type: DataTypes.INTEGER
		}
	},
	{
		//	sequelize, // We need to pass the connection instance
		modelName: 'Inbox', // We need to choose the model name,
		tableName: 'inbox',
		timestamps: false
	}
)

module.exports = (sequelize) => Inbox.init()
