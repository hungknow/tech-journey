import React, { useEffect, useState } from "react";
import { Link, useSearchParams } from "react-router-dom";

export const Error = () => {
  const [error, setError] = useState<string>();
  const [searchParams, setSearchParams] = useSearchParams();

  useEffect(() => {
    const queryError = searchParams.get("error");

    if (queryError !== null) {
      try {
        setError(
          JSON.stringify(JSON.parse(decodeURIComponent(queryError)), null, 2)
        );
      } catch (error) {
        setError(queryError);
      }
    } else {
      setError("Undefined error");
    }
  }, []);

  return (
    <>
      <Link to="/">Home</Link>

      <p>
        An error occurred. Please check the error information below and try
        again.
      </p>

      {error}
    </>
  );
};
