import React, { useEffect, useState } from "react";
import { oryClient, useOrySdk } from "../orySdk";
import { Identity } from "@ory/client";
import { Navigate, useNavigate } from "react-router-dom";

export const Dashboard = () => {
  const [identity, setIdentity] = useState<Identity | null>(null);
  const sdkErrorHandler = useOrySdk(undefined, undefined, "/login", true);
  const navigate = useNavigate();

  useEffect(() => {
    oryClient
      .toSession()
      .then((response) => {
        const session = response.data;
        setIdentity(session.identity);
      })
      .catch(sdkErrorHandler);
  }, []);

  const logOut = () =>
    oryClient
      .createBrowserLogoutFlow(undefined, {
        params: {
          return_url: "/",
        },
      })
      .then((object) => {
        if (object.data.logout_url) {
          window.location.href = object.data.logout_url;
        } else {
          navigate("/");
        }
      })
      .catch(sdkErrorHandler);
  if (!identity) {
    return <>Loading</>;
  }

  return (
    <>
      <p>{identity.id}</p>
      <button onClick={logOut}>Log out</button>
    </>
  );
};
