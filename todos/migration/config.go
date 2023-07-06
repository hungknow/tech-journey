package main

import "github.com/spf13/viper"

type DBConfig struct {
	DbUrl   string
	SqlPath string
}

func LoadDBConfig(paths []string) (config DBConfig, err error) {
	for _, path := range paths {
		viper.AddConfigPath(path)

	}
	viper.SetConfigName("dbconfig")
	viper.SetConfigType("yaml")

	// viper.AutomaticEnv()

	err = viper.ReadInConfig()
	if err != nil {
		return
	}

	err = viper.Unmarshal(&config)
	return
}
