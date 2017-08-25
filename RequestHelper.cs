using System;

namespace PackageManagement
{
    using System.Globalization;
    using NationalInstruments.PackageManagement.Core;
    using Sdk;

    public static class RequestHelper
    {
        public static readonly char NullChar = Convert.ToChar(0x0);
        public static readonly string NullString = new string(NullChar, 1);

        public static string YieldSoftwareIdentity(this Request request, PackageMetadata package)
        {
            var fastPath = string.Join(
                NullString,
                package.PackageName,
                package.GetDisplayVersion(CultureInfo.CurrentCulture),
                package.GetDescription(CultureInfo.CurrentCulture));

            return request.YieldSoftwareIdentity(
                fastPath, // this should be what we need to figure out how to find the package again
                package.PackageName, // this is the friendly name of the package
                package.GetDisplayVersion(CultureInfo.CurrentCulture), "MultiPartNumeric", // the version and version scheme
                package.GetDescription(CultureInfo.CurrentCulture),
                package.FeedName,
                package.GetDisplayName(CultureInfo.CurrentCulture),
                package.Source,
                package.Filename); // a file name in case they want to download it...
        }
    }
}